# nightly is broken - TODO

## symptom

it's been 2 times already:

- the load phase just hangs forever
- the day after I find a ps tree that looks like this:

  ```bash
  - nightly - frisbeed
            - nightly (x35)
  ```

- the log: (killed manually)

  ```bash
  journalctl -u r2lab-nightly.service  --since 2025-04-30T04:00 --until 2025-04-30T11:58:10
  ```

## TODO

- always run through systemctl (the terminal version seems to not be broken - or not as badly)

  ```bash
  systemctl edit r2lab-nightly.service
  ```
- make sure the verbosity is working as expected
- make sure the prologue does not take ages (wtf does it do btw?)
