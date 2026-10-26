# n=5 model=out iset=I1 prefix14_class=12932
mov S1, P2
cmp S1, P3
mov S0, P1
cmovle P2, P3
cmovge S1, P3
cmp P0, P1
cmovg P1, P0
cmovle S0, P0
cmp S0, S1
cmovg P3, S0
cmovle P3, S1
cmovle S1, S0
cmp P2, P1
cmovle S1, P2
