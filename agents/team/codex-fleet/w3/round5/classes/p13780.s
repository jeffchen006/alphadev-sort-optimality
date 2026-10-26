# n=5 model=out iset=I1 prefix14_class=13780
cmp P3, P1
mov S0, P2
cmovg S1, P3
cmovge P3, P1
cmovg P1, S1
cmp S0, P0
cmovge P2, P0
cmovg P0, S0
cmp P1, P0
mov S0, P0
cmovle P0, P1
cmovge S0, P1
cmp P3, P2
cmovle S0, P2
