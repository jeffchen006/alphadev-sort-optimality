# n=5 model=out iset=I1 prefix14_class=5694
mov S0, P1
cmp P1, P0
cmovg P1, P0
cmovge P0, S0
mov S1, P3
cmp S1, P2
cmovge S1, P2
mov S0, P1
cmovg P2, P3
cmp S1, S0
cmovle S0, S1
cmovle S1, P1
cmp P0, P2
cmovge P1, P0
