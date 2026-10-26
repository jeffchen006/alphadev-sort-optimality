# n=5 model=out iset=I1 prefix14_class=6087
cmp P3, P2
mov S0, P3
cmovle P3, P2
cmovle P2, S0
cmp P1, P0
mov S0, P1
cmovle S0, P0
cmovg P1, P0
cmp S0, P3
mov P0, S0
cmovge S0, P3
cmovg P3, P0
mov P0, P1
cmp P1, P2
