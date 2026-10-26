# n=5 model=out iset=I1 prefix14_class=8337
cmp P3, P1
mov S0, P3
cmovge S0, P1
cmovle P3, P1
cmp P2, P0
cmovg S2, P0
mov S1, S0
cmovg P0, P2
cmovg P2, S2
cmp S0, P2
cmovle S0, P2
cmovge S1, P2
mov S1, P3
cmp P3, P0
