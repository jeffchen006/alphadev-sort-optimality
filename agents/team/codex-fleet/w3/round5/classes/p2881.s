# n=5 model=out iset=I1 prefix14_class=2881
cmp P2, P1
cmovle S2, P2
cmovle P2, P1
mov S0, P0
cmovl P1, S2
cmp P0, P3
mov S1, P2
cmovg S0, P3
cmovl P0, P3
cmp P0, P2
cmovle S1, P0
cmovle P0, P2
cmovl P2, S1
mov P3, S0
