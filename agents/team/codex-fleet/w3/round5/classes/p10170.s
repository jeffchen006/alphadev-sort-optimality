# n=5 model=out iset=I1 prefix14_class=10170
cmp P3, P0
mov S1, P3
cmovl P3, P0
mov S0, P1
cmovl P0, S1
cmp P1, P2
cmovg S0, P2
cmovg P2, P1
cmp P3, P2
cmovle S2, P2
cmovle P2, P3
mov P1, P0
cmovl P3, S2
mov P3, P2
