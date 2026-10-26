# n=5 model=out iset=I1 prefix14_class=2565
cmp P1, P0
mov S0, P0
cmovle S0, P1
cmovge P0, P1
mov S2, P2
cmp P3, S2
cmovge S2, P3
cmovg P3, P2
cmp P0, S2
cmovge P2, P0
cmovg P0, S2
cmovl P2, S2
cmp P3, S0
cmovle P1, S0
