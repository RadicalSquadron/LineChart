# LineChart
Line chart with tappable points to reveal value.

This accepts just 6 set of values as of now, need to improve the dynamic handling part.


Sample usage:

Step 1: drag and drop the file into your active project.

Step 2: Create a view and add "LineChart" as its custom class name in storyboard.

Step 3: Create an object for the same view,
            @IBOutlet weak var lineChartView: LineChart!
            
Step 4: Trigger the chart,

                    lineChartView.triggerChart(monthArrayIs: ["2/28","3/31","4/30","5/31","6/30","Today"], valueArrayIs: 
                                                             [190,625,740,827,0,929])
                                                             
                                                             






