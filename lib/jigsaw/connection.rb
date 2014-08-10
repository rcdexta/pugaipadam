require 'java'
require 'lib/jigsaw/ojdbc6.jar'
require 'lib/jigsaw/settings'

module Jigsaw
  class Connection
    class << self

      def fetch_consultants
        rs = statement.execute_query CONSULTANTS_SQL
        consultants = []
        while rs.next
          consultants << consultant_hash_for(rs)
        end
        consultants
      end

      def fetch_projects
        rs = statement.execute_query PROJECSTS_SQL
        projects = []
        while rs.next
          projects << project_hash_for(rs)
        end
        projects
      end

      def close_connections
        @statement.close
        @conn.close
      end

      private
      def consultant_hash_for(row)
        {
          jigsaw_id: row.get_int('id'),
          employee_id: row.get_int('employee_id'),
          name: row.get_string('con_name'),
          email: "#{row.get_string('login_name')}@thoughtworks.com",
          role: row.get_string('role_name'),
          grade: row.get_string('grade_name'),
          tw_experience: exp_from_hire_date(Date.parse row.get_string('hire_date') ),
          experience: row.get_float('years_before_tw').round(1),
          active: (row.get_string('status') == 'A'? true : false)
        }
      end

      def project_hash_for(row)
        {
          jigsaw_id: row.get_string('consultant_id'),
          project_id: row.get_string('project_id'),
          project_name: row.get_string('project_name'),
          account_name: row.get_string('account_name'),
        }
      end

      def exp_from_hire_date(hire_date)
        months = (Time.now.month - hire_date.month) + 12 * (Time.now.year - hire_date.year)
        (months/12.0).round(1)
      end

      def statement
        @statement = conn.create_statement
      end

      def conn
        url = "jdbc:oracle:thin:@#{Settings.host}:#{Settings.port}:#{Settings.sid}"
        @conn ||= java.sql.DriverManager.getConnection(url, Settings.username, Settings.password);
      end

      def driver
        @odriver ||= Java::JavaClass.for_name('oracle.jdbc.driver.OracleDriver')
      end


      CONSULTANTS_SQL = <<-SQL
        select con.id, con.employee_id, con.login_name, con.name as con_name, roles.name as role_name, grades.name as grade_name,
               con.hire_date, con.years_before_tw, con.status
        from consultants con
        join roles on con.role_id = roles.id
        join grades on con.grade_id = grades.id
        where con.office_id = 737701363
      SQL

      PROJECSTS_SQL = <<-SQL
          select ra.consultant_id, pro.id project_id, acc.name account_name, pro.name project_name
          from (select *
                from (select consultant_id,
                            end_date,
                            project_proxy_id,
                            ROW_NUMBER ()
                            OVER (PARTITION BY consultant_id
                            ORDER BY end_date desc) seq_no
                      from assignments
                      where consultant_id in (select id from consultants where office_id = 737701363 and status = 'A')
                    )
                where seq_no = 1
              ) ra
          join project_proxies pro_pro on ra.project_proxy_id = pro_pro.id
          join projects pro on pro_pro.project_id = pro.id
          join accounts acc on pro.account_id = acc.id
      SQL

    end
  end
end
