using DataAccessLayer.Entities;

namespace DataAccessLayer.DTOs
{
    public class TaskDTO
    {
        public int task_id { get; set; }

        public int user_id { get; set; }



        public int status_id { get; set; }

        public int priority_id { get; set; }

        public string title { get; set; } = null!;

        public string? description { get; set; }

        public decimal? estimate_hours { get; set; }

        public DateTime creation_date { get; set; }

        public DateTime last_update_date { get; set; }

        public DateTime? completion_date { get; set; }

        public TaskDTO(
            int task_id,
            int user_id,

            int status_id,
            int priority_id,
            string title,
            string? description,
            decimal? estimate_hours,
            DateTime creation_date,
            DateTime last_update_date,
            DateTime? completion_date)
        {
            this.task_id = task_id;
            this.user_id = user_id;

            this.status_id = status_id;
            this.priority_id = priority_id;
            this.title = title;
            this.description = description;
            this.estimate_hours = estimate_hours;
            this.creation_date = creation_date;
            this.last_update_date = last_update_date;
            this.completion_date = completion_date;
        }

        public static TaskDTO ToDTO(task task)
        {
            return new TaskDTO(
                task.task_id,
                task.user_id,
                task.status_id,
                task.priority_id,
                task.title,
                task.description,
                task.estimate_hours,
                task.creation_date,
                task.last_update_date,
                task.completion_date
            );
        }
    }
}