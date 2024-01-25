namespace BlazorDockerTest.Pages
{
	public partial class Counter
	{
		private int currentCount = 0;
		private string textToShow = "";


		private void IncrementCount()
		{
			currentCount++;
		}

		private void ShowString()
		{
			textToShow = "Il push di docker funziona!";
		}
	}
}
