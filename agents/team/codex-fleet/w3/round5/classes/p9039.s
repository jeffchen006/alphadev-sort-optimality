# n=5 model=out iset=I1 prefix14_class=9039
mov S2, P3
cmp P1, S2
cmovl S2, P1
cmovle P1, P3
cmp P2, P0
cmovge P3, P0
cmovg P0, P2
cmovge P2, P3
cmp P1, P0
cmovle S0, P0
cmovl P0, P1
cmovge S0, P1
cmp S2, P2
cmovge S0, P2
