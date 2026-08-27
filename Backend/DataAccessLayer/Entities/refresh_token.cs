using System;
using System.Collections.Generic;

namespace DataAccessLayer.Entities;

public partial class refresh_token
{
    public int refresh_token_id { get; set; }

    public int user_id { get; set; }

    public string refresh_token_hash { get; set; } = null!;

    public DateTime? expires_at { get; set; }

    public DateTime? revoked_at { get; set; }

    public virtual user user { get; set; } = null!;
}
