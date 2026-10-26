# n=5 model=out iset=I1 prefix14_class=12489
mov S1, P0
cmp P0, P2
cmovg P0, P2
cmovge P2, S1
cmp P3, P1
mov S0, P1
cmovge P1, P3
cmovle S0, P3
cmp P0, S0
cmovge P3, S0
cmovg S0, P0
mov S2, S0
cmovge P0, P3
mov S1, P1
