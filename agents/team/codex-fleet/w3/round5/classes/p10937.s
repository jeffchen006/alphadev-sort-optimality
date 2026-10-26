# n=5 model=out iset=I1 prefix14_class=10937
cmp P1, P2
cmovg S1, P2
cmovle S1, P1
cmovle P1, P2
cmp P0, P3
cmovge P2, P0
cmovg P0, P3
mov S0, P1
cmovg P3, P2
cmp P3, S0
cmovge S0, P3
cmovle P1, P3
cmp S1, P0
cmovle P3, P0
