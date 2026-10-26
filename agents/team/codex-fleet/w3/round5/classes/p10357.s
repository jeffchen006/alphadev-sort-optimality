# n=5 model=out iset=I1 prefix14_class=10357
cmp P3, P2
cmovge S0, P3
cmovle S0, P2
cmovg P3, P2
cmp P1, P0
cmovg P2, P0
cmovg P0, P1
mov S1, P0
cmovg P1, P2
cmp S0, S1
cmovge S1, S0
cmovle P0, S0
cmp P3, P1
mov S0, P1
