<!--- DO NOT EDIT: this file is generated --->

# git stack

A minimal CLI that makes native stacked branches more ergonomic. Integrates with Gitlab and Github.

Core usage:
- `git checkout -b myfeature`: create branches how you normally would
- `git stack branch`: list branches in the current stack, in order
- `git stack push`: push branches in the current stack and open MRs/PRs
- `git stack list`: list all stacks

## What is stacking?

https://graphite.dev/blog/stacked-prs has a good overview on what it is and why you might want to do it.

## What's hard about stacking branches in Git?

Stacking branches is natively supported in Git, and has been made better with recent additions like [`--update-refs`](https://andrewlock.net/working-with-stacked-branches-in-git-is-easier-with-update-refs/). If you stack infrequently, I think the Git CLI provides a good enough out-of-the-box experience.

However, if you stack frequently (or would like to, e.g. to create [small PRs](https://graphite.dev/guides/best-practices-managing-pr-size#why-pull-request-size-matters)), I think the out-of-the-box experience falls short:

- Keeping track of which branches are stacked together, and in which order, is left to the user. If you modify your branches into some degenerate stack, it's also on you to figure out there's even a problem.
- It's not clear how to push all branches in a stack except listing them out individually.
- Once you've pushed your branches, you also need to manually set the target branches on Gitlab/Github. If you want to give reviewers context about other PRs in the stack, that's manual too.

One way to improve things is to adopt a lot of [custom git aliases and shell scripts](https://www.codetinkerer.com/2023/10/01/stacked-branches-with-vanilla-git.html). I did that for a long time, but some things were still hard to automate robustly.

## Why `git stack`?

`git stack` aims to add just enough functionality to make "native stacking" more ergonomic.

There are many [great](https://graphite.dev/) [stacking](https://github.com/aviator-co/av) [tools](https://github.com/gitbutlerapp/gitbutler) already, but most of them require external metadata to keep track of stacks. That means they can innovate more on features and UX, but also that you can't just `git checkout -b myfeature` anymore. `git stack` works entirely on top of native Git. It's stateless, and works by automatically parsing stacks from your commit structure.

In addition, `git stack` helps with the other half of the puzzle. It integrates with both Gitlab and Github to automate creating and updating MRs/PRs from a stack. I was surprised to find that most of the popular stacking tools only support Github.

## Installation

Go version >= 1.22 is required. To install Go on macOS:
```
brew install go 
```

To install `git stack`:
```
go install github.com/raymondji/git-stack-cli/cmd/git-stack@0.32.0
```

## Getting started

The `git stack` binary is named `git-stack`. Git offers a handy trick allowing binaries named `git-<foo>` to be invoked as git subcommands, so `git stack` can be invoked as `git stack`.

`git stack` needs a Gitlab/Github personal access token in order to manage MRs/PRs for you. To set this up:
```
cd ~/your/git/repo
git stack init
```

To learn how to use `git stack`, you can access an interactive tutorial built-in to the CLI:
```
git stack learn
```

## Sample usage

This sample output is taken from `git stack learn --chapter=1 --mode=exec`.

```
╭──────────────────────────────────────────────────╮
│                                                  │
│ Welcome to git stack!                            │
│ Here is a quick tutorial on how to use the CLI.  │
│                                                  │
╰──────────────────────────────────────────────────╯
╭──────────────────────────────────────────────────╮
│                                                  │
│ Let's start things off on the default branch:    │
│                                                  │
╰──────────────────────────────────────────────────╯
> git checkout main
Your branch is ahead of 'origin/main' by 7 commits.
  (use "git push" to publish your local commits)
╭──────────────────────────────────────────────────╮
│                                                  │
│ Next, let's create our first branch:             │
│                                                  │
╰──────────────────────────────────────────────────╯
> git checkout -b myfirststack
> echo 'hello world' > myfirststack.txt
> git add .
> git commit -m 'hello world'
[myfirststack ac36cae] hello world
 1 file changed, 1 insertion(+)
 create mode 100644 myfirststack.txt
╭──────────────────────────────────────────────────╮
│                                                  │
│ Now let's stack a second branch on top of our    │
│ first:                                           │
│                                                  │
╰──────────────────────────────────────────────────╯
> git checkout -b myfirststack-pt2
> echo 'have a break' >> myfirststack.txt
> git commit -am 'break'
[myfirststack-pt2 775025b] break
 1 file changed, 1 insertion(+)
> echo 'have a kitkat' >> myfirststack.txt
> git commit -am 'kitkat'
[myfirststack-pt2 8ab3a74] kitkat
 1 file changed, 1 insertion(+)
╭──────────────────────────────────────────────────╮
│                                                  │
│ So far we've only used standard Git commands.    │
│ Let's see what git stack can do for us already.  │
│                                                  │
│ Our current stack has two branches in it, which  │
│ we can see with:                                 │
│                                                  │
╰──────────────────────────────────────────────────╯
> git stack branch
* myfirststack-pt2 (top)
  myfirststack
╭──────────────────────────────────────────────────╮
│                                                  │
│ Our current stack has 3 commits in it, which we  │
│ can see with:                                    │
│                                                  │
╰──────────────────────────────────────────────────╯
> git stack log
8ab3a74 kitkat
775025b break
ac36cae hello world
╭──────────────────────────────────────────────────╮
│                                                  │
│ We can easily push all branches in the stack up  │
│ as separate PRs.                                 │
│ git stack automatically sets the target branches │
│ for you.                                         │
│                                                  │
╰──────────────────────────────────────────────────╯
> git stack push --create-prs
Pushed myfirststack-pt2: https://github.com/raymondji/git-stack-cli/pull/194
Pushed myfirststack: https://github.com/raymondji/git-stack-cli/pull/193
╭──────────────────────────────────────────────────╮
│                                                  │
│ We can quickly view the PRs at any point using:  │
│                                                  │
╰──────────────────────────────────────────────────╯
> git stack branch --prs
* myfirststack-pt2 (top)
  └── https://github.com/raymondji/git-stack-cli/pull/194

  myfirststack
  └── https://github.com/raymondji/git-stack-cli/pull/193

╭──────────────────────────────────────────────────╮
│                                                  │
│ To sync the latest changes from the default      │
│ branch into the stack, you can run:              │
│ git rebase main --update-refs                    │
│ Or to avoid having to remember --update-refs,    │
│ you can do:                                      │
│                                                  │
╰──────────────────────────────────────────────────╯
> git stack rebase main
Successfully rebased myfirststack-pt2 on main
╭──────────────────────────────────────────────────╮
│                                                  │
│ Great, we've got the basics down for one stack.  │
│ How do we deal with multiple stacks?             │
│ Let's head back to our default branch and create │
│ a second stack.                                  │
│                                                  │
╰──────────────────────────────────────────────────╯
> git checkout main
Your branch is ahead of 'origin/main' by 7 commits.
  (use "git push" to publish your local commits)
> git checkout -b mysecondstack
> echo 'buy one get one free' > mysecondstack.txt
> git add .
> git commit -m 'My second stack'
[mysecondstack 1c4accd] My second stack
 1 file changed, 1 insertion(+)
 create mode 100644 mysecondstack.txt
╭──────────────────────────────────────────────────╮
│                                                  │
│ To view all the stacks:                          │
│                                                  │
╰──────────────────────────────────────────────────╯
> git stack list
  myfirststack-pt2 (2 branches)
* mysecondstack (1 branch)
╭──────────────────────────────────────────────────╮
│                                                  │
│ Nice! All done chapter 1 of the tutorial.        │
│                                                  │
│ In chapter 2 we'll see how to make changes to    │
│ earlier branches in the stack.                   │
│ Once you're ready, continue the tutorial using:  │
│ git stack learn --chapter 2                      │
│                                                  │
│ To cleanup all the branches/PRs that were        │
│ created, run:                                    │
│ git stack learn --chapter 1 --mode=clean         │
│                                                  │
╰──────────────────────────────────────────────────╯

```

## How does it work?

When working with Git we often think in terms of branches as the unit of work, and Gitlab/Github both tie pull requests to branches. Thus, `git stack` presents stacks as "stacks of branches".

However, branches in Git don't inherently make sense as belonging to a "stack", i.e. where one branch is stacked on top of another branch. Branches in Git are just pointers to commits, so:
- Multiple branches can point to the same commit
- Branches don't inherently have a notion of parent branches or child branches

Under the hood, `git stack` therefore walks the commit graph and parses stacking relationships between branches. Commits serve this purpose well because:
- Each commit is a unique entity
- Commits do inherently have a notion of parent commits and child commits

`git stack` uses the commit relationships to try and establish a total order between branches in a stack, i.e. where each branch `i` contains branch `i-1`. If such an order exists, the stack is valid. If such an order doesn't exist, the stack is invalid and `git stack` prints a helpful error message so you can resolve the bad state.

## Attribution

Some code is adapted from sections of https://github.com/aviator-co/av (MIT license). A copy of av's license is included at `attribution/aviator-co/av/LICENSE`.
- `exec.go` is adapted from [aviator-co/av/internal/git/git.go](https://github.com/aviator-co/av/blob/fbcb5bfc0f19c8a7924e309cb1e86678a9761daa/internal/git/git.go#L178)
