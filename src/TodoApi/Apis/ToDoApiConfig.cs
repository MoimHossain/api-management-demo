namespace TodoApi.Apis
{
    public class ToDoApiConfig
    {
        public static void Configure(WebApplication? app)
        {
            if(app != null )
            {
                var todoApiGroup = app.MapGroup("todo");

                todoApiGroup.MapGet("/", () => TodoItemStorage.Instance.List()).WithName("ListToDo").WithOpenApi();
                todoApiGroup.MapGet("/{id}", (int id) => TodoItemStorage.Instance.GetById(id)).WithName("GetToDo").WithOpenApi();
                todoApiGroup.MapPost("/", (TodoItem item) =>
                {
                    TodoItemStorage.Instance.Add(item);
                    return Results.Created($"/todo/{item.Id}", item);
                }).WithName("AddToDo").WithOpenApi();
                todoApiGroup.MapPut("/{id}", (int id, TodoItem item) =>
                {
                    if (id != item.Id)
                    {
                        return Results.BadRequest("Id mismatch");
                    }
                    TodoItemStorage.Instance.Update(item);
                    return Results.Ok();
                }).WithName("UpdateToDo").WithOpenApi();
                todoApiGroup.MapDelete("/{id}", (int id) =>
                {
                    TodoItemStorage.Instance.Delete(id);
                    return Results.NoContent();
                }).WithName("DeleteToDo").WithOpenApi();
            }
        }
    }

    internal record TodoItem(int Id, string Title, string Summary, DateTime DueDate, bool Completed);

    internal class TodoItemStorage
    {
        internal static TodoItemStorage Instance = new();
        private readonly List<TodoItem> _items = [];
        private TodoItemStorage()
        {
            _items.Add(new TodoItem(1, "Todo1", "Summary1", DateTime.Now, false));
            _items.Add(new TodoItem(2, "Todo2", "Summary2", DateTime.Now, false));
        }
        public IEnumerable<TodoItem> List() => _items;
        public TodoItem? GetById(int id) => _items.FirstOrDefault(x => x.Id == id);
        public void Add(TodoItem item) => _items.Add(item);
        public void Update(TodoItem item)
        {
            var index = _items.FindIndex(x => x.Id == item.Id);
            if (index >= 0)
            {
                _items[index] = item;
            }
        }
        public void Delete(int id) => _items.RemoveAll(x => x.Id == id);
    }
}
