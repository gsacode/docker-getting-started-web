using System.Collections.Generic;
using Microsoft.AspNetCore.Mvc;

namespace DockerHelloWorldWeb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : Controller
    {
        // GET api/values
        [HttpGet]
        public ActionResult<IEnumerable<string>> Get()
        {
            return new List<string> {"value1", "value2" };
        }
    }
}
