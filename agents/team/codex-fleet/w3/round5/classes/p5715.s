# n=5 model=out iset=I1 prefix14_class=5715
cmp P1, P2
mov S0, P2
cmovle S0, P1
cmovge P2, P1
cmp P0, P3
mov P1, P3
cmovge P3, P0
cmovge P0, P1
mov P1, P0
cmp P1, S0
cmovg P0, S0
cmovg S0, P1
cmp P3, P2
cmovge S1, P2
