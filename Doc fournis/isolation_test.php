<html>
  <head>
    <title>SharedHosting: Isolation test</title>
  </head>
  <body>
    <h1>What</h1>
    <form method="post">
      <p><input name="dir_path" value="<?= isset($_POST['dir_path']) ? $_POST['dir_path'] : '/var/www' ?>" style="width: 100%"></p>
      <p>
        <input type="submit" name="shell_exec_ls" value="shell_exec('ls ...')">
        <input type="submit" name="system_ls" value="system('ls ...')">
      </p>
      <br>
      <p><input name="file_path" value="<?= isset($_POST['file_path']) ? $_POST['file_path'] : '/var/www/some_user/public_html/index.php' ?>" style="width: 100%"></p>
      <p>
        <input type="submit" name="shell_exec_cat" value="shell_exec('cat ...')">
        <input type="submit" name="system_cat" value="system('cat ...')">
        <input type="submit" name="php_cat" value="file_get_contents('...')">
      </p>
    </form>

    <h1>Result</h1>
    <pre><?php
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
      // ls
      if (isset($_POST['shell_exec_ls'])) {
        echo shell_exec('ls -als '.escapeshellarg($_POST['dir_path']));
      }
      elseif (isset($_POST['system_ls'])) {
        system('ls -als '.escapeshellarg($_POST['dir_path']), $retval);
        echo "\nRetval: $retval";
      }
      // cat
      elseif (isset($_POST['shell_exec_cat'])) {
        echo htmlentities(shell_exec('cat '.escapeshellarg($_POST['file_path'])));
      }
      elseif (isset($_POST['system_cat'])) {
        system('cat '.escapeshellarg($_POST['file_path']), $retval);
        echo "\nRetval: $retval";
      }
      elseif (isset($_POST['php_cat'])) {
        echo htmlentities(file_get_contents($_POST['file_path']));
      }
    }
    ?>
    </pre>

    <h1>Linux users</h1>
    <pre><?= htmlentities(file_get_contents('/etc/passwd')); ?></pre>

  </body>
</html>
