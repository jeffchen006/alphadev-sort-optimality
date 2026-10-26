# n=5 model=out iset=I1 prefix14_class=8062
cmp P2, P1
cmovle S1, P1
cmovl P1, P2
cmovle P2, S1
mov S0, P0
cmp S0, P3
cmovg P0, P3
cmovge P3, S0
mov S2, P0
cmp S2, P1
cmovge S2, P1
cmovle P0, P1
cmp P3, P2
cmovge S2, P3
