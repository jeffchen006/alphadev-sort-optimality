# n=5 model=out iset=I1 prefix14_class=5025
mov S1, P1
cmp P3, S1
cmovle S1, P3
cmovg P1, P3
cmp P0, P2
mov P3, P1
cmovle S0, P2
cmovle P2, P0
cmovle P0, S0
cmp S1, P2
cmovge S0, P2
cmovg P2, S1
cmovge S1, S0
cmp P0, P3
