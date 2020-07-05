### Quick introduction of what is Weber Fraction

The weber fraction is a known neuropsychological construct that takes into account how the brain processes information of the same type in different magnitudes of the same type.
A fully known example is when someone carries one weight with one hand and another weight with the other hand, one weighting twice as much of the other. People cannot tell if its exactelly the double or not.

What people notice about the comparison of the weights varies with their magnitude, according to the formula bellow.

**K = Δi / i** 

*i being the magnitude of the stimulus (how many kilograms in the weight of reference, in our example) and Δi the difference between the magnitudes*

### Weber Fraction in the study of Math Learning Disabilities
The Non-Symbolic Weber Fraction is a measure of how a person perceives quantities presented in a way they cannot count, such as the number of dots in a screen.
In the Developmental Neuropsychology Laboratory, three tasks were created, repetedly showing two arrays of points in a screen to a child, varying the number of dots, and they should say which one had more points.
The accuracy usually increases as the difference between the two arrays gets increases. In the formula, the difference is the *Δi* and the magnitude of reference is *i*.

To calculate the Non-Symbolic Weber Fraction for each child, we had to work on the spreadsheet given to us as an output of the task. We also calculated the fit and Rsquared for each children, and some other variables. With those calculations, we extract more information and not only the Weber Fraction for each child.

Several authors in Neuropsychology study the relationship of the Non-Symbolic Weber Faction and the Symbolic process of children, researching if they can predict Math Learning Disabilities such as Discalculia. A literature review is beyond the scope of this portfolio.


### The scrips presented in this folder
- In this first script I have created a function that takes as an input a spreadsheet and gives back the scores we want to calculate: the Weber Fraction, the fit, the R-squared, the value "p" (another neuropsychological construct, diferent from the p-value in statistics), which task does it refer to etc.
The input spreadsheet can be from any of the three tasks. The tasks are similar, what changes is the number of output columns, their names and positions. To create the function, I used parts of a script made by Pedro Pinheiro Chagas and Ricardo José de Moura.
- The second script was a way of checking the results. Most of the Weber Fractions have been already calculated by hand, but the results were not so realiable and the fit wasn't calculated. So I calculated again the Weber, added the other columns, and compared my results with the previous ones to see how many children had the W score and didn't have anymore (the spreadsheet was lost), or other problems that may have happened. The inspection was explaind in a text document made available to the professor and other students, and it was also displayed in this folder (to demonstrate how I organized this step). The text is in Portuguese so it can be easier for the students to understand. The next step, correcting the mistakes was done by the person in charge of data collection, not me.
