#[no_std]
/*
 * tty
 */
use printc
fn tty()
{
    let mut ch;
    loop {
        if (ch == '\n')
        {
            puts('\0');
        }
    }
}
