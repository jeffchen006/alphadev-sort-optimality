# n=5 model=out iset=I1 prefix14_class=6737
mov S1, P0
cmp P2, S1
cmovge P0, P2
cmovge P2, S1
cmp P3, P1
mov S0, P3
cmovg P3, P1
cmovle S0, P1
cmp P0, S0
cmovg P1, P0
cmovg P0, S0
cmovg S0, P1
cmp P3, P2
cmovge P1, P3
