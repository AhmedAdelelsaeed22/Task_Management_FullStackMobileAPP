using BussinessLayer;
using DataAccessLayer.Data;
using DataAccessLayer.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace TaskManagementAPI.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class TaskController : Controller
    {

        private readonly ApplicationDbContext _context;

        public TaskController(ApplicationDbContext context)
        {
            _context = context;
        }

        private static void _UpdateNewData(TaskDTO NewTaskData, TaskService OldDataBeforeUpdated)
        {

            OldDataBeforeUpdated.user_id = NewTaskData.user_id;
            OldDataBeforeUpdated.status_id = NewTaskData.status_id;
            OldDataBeforeUpdated.priority_id = NewTaskData.priority_id;
            OldDataBeforeUpdated.title = NewTaskData.title;
            OldDataBeforeUpdated.description = NewTaskData.description;
            OldDataBeforeUpdated.estimate_hours = NewTaskData.estimate_hours;
            OldDataBeforeUpdated.creation_date = NewTaskData.creation_date;
            OldDataBeforeUpdated.last_update_date = NewTaskData.last_update_date;
            OldDataBeforeUpdated.completion_date = NewTaskData.completion_date;
        }


        [HttpGet("GetAllTasksUsingUserId/{userId}", Name = "GetAllTasksUsingUserId")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<IEnumerable<TaskDTO>>> GetAllTasksUsingUserId(int userId, [FromServices] IAuthorizationService authorizationService)
        {
            List<TaskDTO> Tasks = await TaskService.GetAllTasksForUserAsync(userId, _context);

            if (Tasks.Count == 0)
            {
                return NotFound("Not Found Any Tasks For this User");
            }

            var authResult = await authorizationService.AuthorizeAsync(
             User,
             userId,
             "UserOwnerOrAdmin");

            if (!authResult.Succeeded)
                return Forbid(); // 403

            return Ok(Tasks);
        }


        [HttpGet("{TaskId}", Name = "GetTaskUsingID")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<TaskDTO>> GetTaskUsingID(int TaskId)
        {
            if (TaskId < 0)
            {
                return BadRequest("Invalid Task ID");
            }

            TaskService? TaskInfo = await TaskService.FindAsync(TaskId, _context);

            if (TaskInfo == null)
            {
                return NotFound("Not Found This Task");
            }

            return Ok(TaskInfo.TDTO);
        }


        [HttpPost("InsertNewTask", Name = "InsertNewTask")]
        [ProducesResponseType(StatusCodes.Status201Created)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<ActionResult<TaskDTO>> InsertNewTask(TaskDTO NewTaskDTO)
        {
            if (NewTaskDTO == null)
            {
                return BadRequest("Invalid Data");
            }

            TaskService TaskInfo = new TaskService(NewTaskDTO);

            await TaskInfo.Save(_context);

            NewTaskDTO.task_id = TaskInfo.task_id;

            return CreatedAtRoute(
                "GetTaskUsingID",
                new { TaskId = NewTaskDTO.task_id },
                NewTaskDTO);
        }


        [HttpPut("UpdateTaskData", Name = "UpdateTask")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult<TaskDTO>> UpdateTask(TaskDTO NewTaskInfo)
        {
            if (NewTaskInfo.task_id < 0)
            {
                return BadRequest("Invalid Data Or Invalid ID");
            }

            TaskService? TaskInfo = await TaskService.FindAsync(NewTaskInfo.task_id, _context);

            if (TaskInfo == null)
            {
                return NotFound("Not Found This Task");
            }

            _UpdateNewData(NewTaskInfo, TaskInfo);

            await TaskInfo.Save(_context);

            return Ok(TaskInfo.TDTO);
        }


        [HttpPut("CompletedTask/{TaskId}", Name = "CompletedTask")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> CompletedTask(int TaskId)
        {
            if (TaskId < 0)
            {
                return BadRequest("Invalid Data Or Invalid ID");
            }


            if (!await TaskService.CompletedTaskAsync(TaskId, _context))
            {
                return NotFound("Task Is Not Found");
            }



            return Ok();
        }


        [HttpDelete("DeleteTask/{TaskId}", Name = "DeleteTask")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        public async Task<ActionResult> DeleteTask(int TaskId)
        {
            if (TaskId < 0)
            {
                return BadRequest("Invalid ID");
            }

            if (await TaskService.DeleteTaskAsync(TaskId, _context))
            {
                return Ok($"Delete Is Successfully For Task With ID -> {TaskId}");
            }
            else
            {
                return NotFound($"Delete Is Not Successfully For Task With ID -> {TaskId} Or Not Found This Task");
            }
        }

    }
}