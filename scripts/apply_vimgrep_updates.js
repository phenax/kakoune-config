#!/usr/bin/env bun

const main = async () => {
  let count = 0
  for await (const line of console) {
    const [_, filepath, row, _col, text] = line.match(/(.*):(\d+):(\d+):(.*)/) ?? []
    if (filepath) {
      const isApplied = await apply_edit(filepath, Number(row), text);
      if (isApplied) count++
    }
  }
  return count
}

const apply_edit = async (filepath, row, text) => {
  if (!Number.isFinite(row) || row <= 0) return false;
  const file = Bun.file(filepath)
  const lines = (await file.text()).split('\n')
  if (lines.length > row) {
    lines[row - 1] = text
    await Bun.write(filepath, lines.join('\n'))
    return true
  }
  return false
}

const changesCount = await main()
console.log(`Applied ${changesCount} changes`)

