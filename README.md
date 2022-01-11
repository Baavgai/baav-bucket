# baav-bucket

The initial test: https://scoop-docs.vercel.app/docs/concepts/Buckets.html#creating-your-own-bucket

## Creating your own bucket

Here's an example of one way you might go about creating a new bucket, using GitHub to host it. You don't have to use GitHub though—you can use whatever source control repo you like, or even just a Git repo on your local or network drive.

1. Create a new GitHub repo called e.g. `my-bucket`
2. Add an app to your bucket. In a powershell session:

```powershell
git clone https://github.com/<your-username>/my-bucket
cd my-bucket
'{ version: "1.0", url: "https://gist.github.com/lukesampson/6446238/raw/hello.ps1", bin: "hello.ps1" }' > hello.json
git add .
git commit -m "add hello app"
git push
```

3. Configure Scoop to use your new bucket:

```powershell
scoop bucket add my-bucket https://github.com/<your-username>/my-bucket
```

4. Check that it works:

```powershell
scoop bucket list # -> you should see "my-bucket"
scoop search hello # -> you should see `hello` listed under, "my-bucket bucket:"
scoop install hello
hello # -> you should see "Hello, <windows-username>!"
```

5. To share your bucket, all you need to do is tell people how to add your bucket, i.e. by running the command in step 3. If you want your bucket listed in the [Scoop Directory](https://github.com/rasa/scoop-directory) , add a topic of `scoop-bucket` to its github page.

git init
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:Baavgai/baav-bucket.git
git push -u origin main