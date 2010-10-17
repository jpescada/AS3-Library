package lib.utils
{
	/**
	 * A utility class that uses a static method to check whether a user's age is older than the age to check against.
	 *
	 * @author Calvin Ly [http://www.calvinly.com]
	 * @author Conversion to class by Matt Przybylski [http://www.reintroducing.com]
	 * @version 1.0
	 */
	public class AgeChecker
	{
		public function AgeChecker():void{}

		/**
		 * Checks whether the user's age is permissible or not.  The month and day can be passed in with leading zeros or not.
		 * The year should be passed in as the full year (ex: 1983).
		 *
		 * @param $ageToCheck The age you want to test against
		 * @param $month The user's input month
		 * @param $day The user's input day
		 * @param $year The user's input year
		 *
		 * @return A boolean value that states whether the age check has passed or not.
		 */
		public static function checkAge($ageToCheck:int, $month:int, $day:int, $year:int):Boolean
		{
			var todayDate:Date = new Date();
			var currentMonth:int = (todayDate.getMonth() + 1);
			var currentDay:int = todayDate.getDate();
			var currentYear:int = todayDate.getFullYear();
			var userMonth:int = $month;
			var userDay:int = $day;
			var userYear:int = $year;
			var yearDiff:int = (currentYear - userYear);
			if (yearDiff == $ageToCheck)
			{
				// AGE IS EQUAL to VALID AGE ... need to check month and day
				var monthDiff:int = (currentMonth - userMonth);
				if (monthDiff == 0)
				{
					// MONTH IS EQUAL ... need to check day
					var dayDiff:int = currentDay - userDay;
					if (dayDiff>= 0)
					{
						// DAY IS EQUAL OR GREATER .. PASS
						return true;
					}
					else
					{
						// DAY INVALID ... too young
						return false;
					}
				}
				else if (monthDiff <0)
				{
					// MONTH INVALID ... too young
					return false;
				}
				else
				{
					// AGE PASS
					return true;
				}
			}
			else if (yearDiff <$ageToCheck)
			{
				// YEAR INVALID ... too young
				return false;
			}
			else
			{
				// OVER AGE in YEARS
				return true;
			}
		}
	}
}