# n=5 model=out iset=I1 prefix14_class=1462
cmp P2, P0
mov S2, P1
cmovle S0, P2
cmovg S0, P0
cmovg P0, P2
cmp P1, P3
cmovl P1, P3
cmovle P3, S2
cmovg S2, P3
mov P2, P1
cmp P0, P1
cmovg P1, P0
cmovg P0, P2
mov P1, P0
