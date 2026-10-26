# n=5 model=out iset=I1 prefix14_class=8642
cmp P3, P2
cmovle S0, P3
cmovge S0, P2
cmovle P3, P2
mov S2, P3
cmp P1, P0
cmovle P2, P0
cmovge P2, P1
cmovl P0, P1
cmp P2, P3
cmovg P3, P2
cmovle S2, P2
cmp S0, P0
cmovge S1, P0
