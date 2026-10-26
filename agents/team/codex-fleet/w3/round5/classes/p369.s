# n=5 model=out iset=I1 prefix14_class=369
cmp P3, P1
cmovle S2, P1
cmovg S2, P3
cmovg P3, P1
cmp P2, P0
mov S0, P3
cmovge S1, P2
cmovge P2, P0
cmovg P0, S1
cmp P2, S0
cmovle S0, P2
cmovle P2, P3
cmp S2, P0
mov S1, P0
