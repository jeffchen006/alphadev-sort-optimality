# n=5 model=out iset=I1 prefix14_class=8618
mov S2, P3
cmp P0, P3
cmovle P3, P0
cmovge S2, P0
cmp P1, P2
cmovg S1, P1
cmovge P1, P2
cmovg P2, S1
mov S0, P3
cmp P2, S2
cmovge S1, S2
cmovg S2, P2
cmovge P2, S1
cmp P3, P1
