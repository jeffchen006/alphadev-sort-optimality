# n=5 model=out iset=I1 prefix14_class=1601
cmp P3, P0
mov S0, P1
cmovge S2, P3
cmovge P3, P0
cmovg P0, S2
mov S1, P0
mov S2, P3
cmp P2, S0
cmovg S0, P2
cmovle P1, P2
cmp P3, P1
cmovle P3, P1
cmovle P1, S2
cmovle S2, P3
