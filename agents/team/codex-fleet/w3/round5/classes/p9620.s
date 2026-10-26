# n=5 model=out iset=I1 prefix14_class=9620
cmp P0, P1
mov S2, P3
cmovge S1, P0
cmovge P0, P1
cmovg P1, S1
cmp P3, P2
cmovle S2, P2
mov S0, P1
cmovge P3, P2
cmp S0, S2
cmovg P1, S2
cmovg S2, S0
cmp P3, P0
cmovle S2, P3
