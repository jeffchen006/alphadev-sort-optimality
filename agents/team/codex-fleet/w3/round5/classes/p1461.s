# n=5 model=out iset=I1 prefix14_class=1461
cmp P2, P1
mov S2, P0
cmovle S0, P2
cmovg S0, P1
cmovg P1, P2
cmp P0, P3
cmovl P0, P3
cmovle P3, S2
cmovg S2, P3
mov P2, P0
cmp P1, P0
cmovg P0, P1
cmovg P1, P2
mov P0, P1
