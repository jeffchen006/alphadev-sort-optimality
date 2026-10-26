# n=5 model=out iset=I1 prefix14_class=265
mov S2, P1
mov S0, P2
cmp P1, P0
cmovge P1, P0
cmovge P0, S2
cmp P3, P2
cmovle S0, P3
mov S2, P1
cmovg P2, P3
cmp S0, P1
cmovl P1, S0
cmovl S0, S2
cmp P0, P2
cmovle P3, P2
