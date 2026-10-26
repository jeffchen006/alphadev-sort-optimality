# n=5 model=out iset=I1 prefix14_class=11596
cmp P2, P1
cmovg S0, P1
cmovle S0, P2
cmovl P2, P1
mov P1, P3
cmp P1, P0
cmovle P1, P0
cmovg P3, P0
cmp S0, P3
mov P0, P2
cmovle S1, P3
cmovle P3, S0
cmovl S0, S1
mov P3, S0
