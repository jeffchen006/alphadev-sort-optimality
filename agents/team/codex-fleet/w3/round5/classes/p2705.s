# n=5 model=out iset=I1 prefix14_class=2705
cmp P0, P1
mov S2, P0
cmovle S2, P1
cmovl P1, P0
mov S0, S2
mov P0, P2
cmp P2, P3
cmovl P2, P3
cmovle P3, P0
cmp P2, S0
cmovle S0, P2
cmovle P2, S2
cmp P3, P1
cmovle S2, S0
