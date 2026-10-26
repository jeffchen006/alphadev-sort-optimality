# n=5 model=out iset=I1 prefix14_class=2928
mov S0, P2
cmp P1, P0
mov S2, P0
cmovg P0, P1
cmovl S2, P1
cmp P3, S0
cmovg P2, P3
cmovge P3, S0
cmp P0, P2
mov S1, S2
cmovle S0, P2
cmovle P2, P0
cmovl P0, S0
cmp P3, S2
