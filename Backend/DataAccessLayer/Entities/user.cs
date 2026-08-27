using System;
using System.Collections.Generic;

namespace DataAccessLayer.Entities;

public partial class user
{
    public int user_id { get; set; }

    public string full_name { get; set; } = null!;

    public string user_name { get; set; } = null!;

    public string email_address { get; set; } = null!;

    public string password_hash { get; set; } = null!;

    public string? job_title { get; set; }

    public string? time_zone { get; set; }

    public string account_status { get; set; } = null!;

    public DateTime? date_created { get; set; }

    public DateTime last_login_date { get; set; }

    public string user_role { get; set; } = null!;

    public virtual ICollection<refresh_token> refresh_tokens { get; set; } = new List<refresh_token>();

    public virtual ICollection<task> tasks { get; set; } = new List<task>();
}
