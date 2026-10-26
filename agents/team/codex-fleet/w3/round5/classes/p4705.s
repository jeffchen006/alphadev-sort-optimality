# n=5 model=out iset=I1 prefix14_class=4705
mov S0, P1
cmp P3, S0
cmovge P1, P3
cmovle S0, P3
mov S2, P0
cmp S2, P2
cmovg P0, P2
cmovge P2, S2
cmp P1, P2
mov S2, P1
cmovl P1, P2
cmovge S2, P2
cmp S0, P0
cmovle P3, S0
