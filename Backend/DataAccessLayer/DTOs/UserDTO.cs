using DataAccessLayer.Entities;

namespace DataAccessLayer.DTOs
{
    public class UserDTO
    {
        public int user_id { get; set; }

        public string full_name { get; set; } = null!;

        public string user_name { get; set; } = null!;

        public string email_address { get; set; } = null!;

        public string password { get; set; } = null!;



        public string? job_title { get; set; }

        public string? time_zone { get; set; }

        public string account_status { get; set; } = null!;

        public DateTime? date_created { get; set; }

        public DateTime last_login_date { get; set; }

        public string user_role { get; set; } = null!;

        public UserDTO(int user_id, string full_name, string user_name, string email_address, string password, string? job_title, string? time_zone, string account_status, DateTime? date_created, DateTime last_login_date, string user_role)
        {
            this.user_id = user_id;
            this.full_name = full_name;
            this.user_name = user_name;
            this.email_address = email_address;
            this.password = password;

            this.job_title = job_title;
            this.time_zone = time_zone;
            this.account_status = account_status;
            this.date_created = date_created;
            this.last_login_date = last_login_date;
            this.user_role = user_role;
        }

        public static UserDTO ToDTO(user user)
        {
            return new UserDTO(
           user.user_id,
           user.full_name,
           user.user_name,
           user.email_address,
           user.password_hash,

           user.job_title,
           user.time_zone,
           user.account_status,
           user.date_created,
           user.last_login_date,
           user.user_role
   );
        }
    }
}
