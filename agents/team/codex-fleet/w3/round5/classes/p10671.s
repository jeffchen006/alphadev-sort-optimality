# n=5 model=out iset=I1 prefix14_class=10671
cmp P1, P3
cmovg S2, P3
cmovle S2, P1
cmovle P1, P3
cmp P2, P0
cmovge S1, P0
cmovge P0, P2
cmovg P2, S1
cmp P1, P0
cmovge S0, P0
cmovg P0, P1
cmovle S0, P1
mov P3, P2
mov P0, S0
