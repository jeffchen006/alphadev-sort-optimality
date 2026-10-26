# n=5 model=out iset=I1 prefix14_class=13384
mov S2, P3
cmp S2, P2
cmovg P3, P2
mov S0, P1
cmovge P2, S2
cmp P0, S0
cmovg P1, P0
cmovle S0, P0
cmp S0, P3
cmovle P0, P3
cmovle P3, S0
cmovle S0, P0
cmp P1, P2
cmovl P0, P2
