
# Table of Contents

1.  [mainspring-org-prettify](#org3755b49)
    1.  [Overview](#orgfd2f647)
    2.  [Installation](#orgd5a9fc7)


<a id="org3755b49"></a>

# mainspring-org-prettify

Substitute characters in org mode for prettier alternatives.

![img](mainspring-org-prettify.png)


<a id="orgfd2f647"></a>

## Overview

mainspring-org-prettify can substitute a wide variety of cahracters in org documents for prettier alternatives. There are:

-   Headline stars
-   TODO
-   DONE
-   Unchecked checkbox
-   Checked checkbox
-   Plain list bullet

Its killer feature is the pretty headline stars replacement still has a meaningful level indicator.


<a id="orgd5a9fc7"></a>

## Installation

This uses PragmataPro fonts which are non-free. Once the fonts are installed it can be installed with straight like:

    (use-package mainspring-org-prettify
      :defer t
      :straight (:type git :host github :repo "JonathanHope/mainspring-org-prettify" :branch "master" :files ("mainspring-org-prettify.el"))

      :commands (mainspring-org-prettify-mode)

      :init
      (add-hook 'org-mode-hook 'mainspring-org-prettify-mode))
