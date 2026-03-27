Pedigrypst is a package for drawing [pedigrees](https://en.wikipedia.org/wiki/Pedigree_chart).

## Examples

<table>
<tr>
<td>
    <a href="https://raw.githubusercontent.com/CrowdingFaun624/pedigrypst/0.1.0/example/example1.typ">
        <img src="https://raw.githubusercontent.com/CrowdingFaun624/pedigrypst/0.1.0/example/example1.png"/>
    </a>
</td>
<td>
    <a href="https://raw.githubusercontent.com/CrowdingFaun624/pedigrypst/0.1.0/example/example2.typ">
        <img src="https://raw.githubusercontent.com/CrowdingFaun624/pedigrypst/0.1.0/example/example2.png"/>
    </a>
</td>
</tr>
</table>

## Usage

For information, check the [manual](https://raw.githubusercontent.com/CrowdingFaun624/pedigrypst/0.1.0/docs/manual.pdf).

To use this package, simply add the following code to your document:

```typ
#import "@preview/pedigrypst:0.1.0" as pedigrypst: pedigree

#pedigree({
  import pedigrypst: *
  // Pedigree data here
  individual(1, 1, "male")
})
```
