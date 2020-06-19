# Here I explain a little about the project and the codes

It is still under construction, as the project is in its initial steps.

The first code in this folder is an R script for web scrapping. With this code I got all Bolsonaro's speeches from the "Camara dos Deputados" website. This website has a transcript of all the speeches from Bolsonaro as well of other important politicians such as last presidents and other deputies made in this place that is more or less like a Parliament (with Brazilian specificities, of course).

The link for the table with the links is: https://www.camara.leg.br/internet/sitaqweb/resultadoPesquisaDiscursos.asp?txOrador=jair+bolsonaro&txPartido=&txUF=&dtInicio=&dtFim=&txTexto=&txSumario=&basePesq=plenario&CampoOrdenacao=dtSessao&PageSize=50&TipoOrdenacao=DESC&btnPesq=Pesquisar
Here I put some screenshots to become easier to understand the project.

When the search tool is used with the input "Jair Bolsonaro", the following web page appears:

![Screen Shot 2020-06-19 at 16 56 10](https://user-images.githubusercontent.com/62617360/85176556-721f4080-b250-11ea-8b20-07cb4eba660d.png)

In the table on the end of the page we can see a green icon in the "Discurso" column. This is the hyperlink to the speech made in this date.
Our script goes to this hyperlink and gets its speech. A sample of the webpage for the first hyperlink can be seen bellow:

![Screen Shot 2020-06-19 at 17 06 32](https://user-images.githubusercontent.com/62617360/85176533-616eca80-b250-11ea-9f86-28f0ee8aad11.png)

Disclosure: all the screenshots, links and data were extracted on 19/06/2020, this can be changed in the future as speeches have been constantly added to this website.

Later steps in this project will be posted in this repository when they have been concluded.
