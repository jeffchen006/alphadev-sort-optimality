# n=5 model=out iset=I1 prefix14_class=9215
cmp P1, P3
mov S2, P1
cmovge P1, P3
cmovle S2, P3
mov S1, P0
cmp P2, P0
cmovg P0, P2
cmovle S1, P2
cmp P1, S1
cmovge P2, P1
cmovg P1, S1
cmovge S1, P2
mov S0, P0
cmp S2, S0
