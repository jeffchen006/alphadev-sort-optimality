# n=5 model=out iset=I1 prefix14_class=12940
mov S2, P3
cmp P2, P3
cmovl S2, P2
cmovge P3, P2
mov S0, P1
cmp P1, P0
cmovg P1, P0
cmovle S0, P0
cmp P1, S2
cmovle P2, S2
cmovle S2, P1
mov S2, S0
cmovl P1, P2
cmp P3, S2
