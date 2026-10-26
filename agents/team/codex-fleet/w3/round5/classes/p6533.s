# n=5 model=out iset=I1 prefix14_class=6533
cmp P1, P3
cmovg S2, P1
cmovg P1, P3
cmovg P3, S2
cmp P2, P0
cmovle S0, P0
cmovg S0, P2
cmovl P0, P2
cmovl P2, S0
cmp P2, P3
cmovg S0, P3
cmovle P2, P3
cmp P1, P0
mov P2, P0
