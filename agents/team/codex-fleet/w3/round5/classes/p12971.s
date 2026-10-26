# n=5 model=out iset=I1 prefix14_class=12971
mov S2, P0
cmp S2, P1
cmovl S2, P1
cmovge P0, P1
cmp P3, P2
mov P1, P3
cmovge P1, P2
cmovle P3, P2
cmp P1, P0
cmovge S0, P0
cmovg P0, P1
cmovge P1, S0
cmp P3, S2
cmovle S0, P3
